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

  /// append to existing text sequence
  public func addText(id : Id, t : Text) : async Bool {
    switch (db.read(id)) {
      case (#ok(seq)) {
             let (seq2, _) = Sequence.add(seq, t);
             switch (db.update(id, seq2)) {
               case (#ok(())) { true };
               case _ { false };
             }
           };
      case (#err(e)) { false };
    }
  };

  /// read a text sequence
  public func read(id : Id) : async ?TextSeq {
    switch (db.read(id)) {
    case (#ok(seq)) { ?seq };
    case (#err(_)) { null };
    }
  };
}
