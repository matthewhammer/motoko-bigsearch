import Sequence "mo:sequence/Sequence";
import Db "mo:crud/Database";

import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";

actor {

  // temp
  flexible var count = 0;

  public type Id = Nat;

  // sequence of text

  public type TextSeq = Sequence.Sequence<Text>;

  let append = Sequence.defaultAppend();

  // database of text
  flexible var db = Db.Database<Nat, TextSeq>(
    func (_, last) {
      switch last {
      case null 0;
      case (?last) { last + 1 };
    }},
    Nat.equal,
    #hash(Hash.hash),
  );

  /// create a new text sequence
  public func create(t : Text) : async Id {
    db.create(Sequence.make(t))
  };

  /// delete a text sequence
  public func delete(id : Id) : async Bool {
    switch (db.delete(id)) {
      case (#ok(_)) true;
      case (#err(_)) false;
    }
  };

  /// append to an existing text sequence
  public func addText(id : Id, t : Text) : async Bool {
    switch (db.read(id)) {
      case (#ok(seq)) {
             let seq2 = append<Text>(seq, Sequence.make(t));
             switch (db.update(id, seq2)) {
               case (#ok(())) { true };
               case _ { false };
             }
           };
      case (#err(e)) { false };
    }
  };


  /// read a text sequence
  public func readText(id : Id) : async ?TextSeq {
    switch (db.read(id)) {
    case (#ok(seq)) { ?seq };
    case (#err(_)) { null };
    }
  };

  /// read a text sequence slice
  public func readSlice(id : Id, pos : Nat, size : Nat) : async ?TextSeq {
    switch (db.read(id)) {
    case (#ok(seq)) { ?seq }; // to do -- fix this code
    case (#err(_)) { null };
    }
  };

  // to do -- more CRUD slice messages: putSlice, deleteSlice
  //   Use mo:sequence

  // to do -- top words (rank all words, by freq, across all db)
  //   Use mo:sequence/Sort and mo:sequence/TextSeq
  //         tokens - get all words
  //         sort   - put words into lex order
  //         count  - count words that appear more than once
  //         sort   - sort word-count pairs by their count

  // to do -- search words (find word in ranking, and give ids for CRUD)

  // TEMP ----------

  public func selfTest() {
    Debug.print "hello"
  };

  public func doNextCall() : async Bool {
    false
  };
}
