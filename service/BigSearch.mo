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

  public type TextFile = {
    name : ?Text; // perhaps un-needed?
    meta : ?Text; // e.g., CanCan stores video ID here (or whatever helps render search results visually)
    var content : TextSeq; // e.g., CanCan stores some video-related text here, like a comment, explicit hashtag(s), etc
  };

  let append = Sequence.defaultAppend();

  // database of text
  flexible var db = Db.Database<Nat, TextFile>(
    func (_, last) {
      switch last {
      case null 0;
      case (?last) { last + 1 };
    }},
    Nat.equal,
    #hash(Hash.hash),
  );

  /// create a new text sequence
  public func create(n : ?Text, m : ?Text, c : Text) : async Id {
    db.create({ name = n; meta = m; var content = Sequence.make(c)})
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
      case (#ok(file)) {
             file.content := append(file.content, Sequence.make(t));
             true
           };
      case (#err(e)) { false };
    }
  };


  /// read a text sequence (to do -- "flatten"/simplify to Text, for easier JS usage)
  public func readText(id : Id) : async ?TextSeq {
    switch (db.read(id)) {
    case (#ok(file)) { ?file.content };
    case (#err(_)) { null };
    }
  };

  /// read a text sequence slice (to do -- "flatten"/simplify to Text, for easier JS usage)
  public func readSlice(id : Id, pos : Nat, size : Nat) : async ?TextSeq {
    switch (db.read(id)) {
    case (#ok(file)) { ?file.content }; // to do -- fix this code
    case (#err(_)) { null };
    }
  };

  // SearchResult is nearly the entire file,
  // but instead of full content,
  // uses only the position of search result in that content
  public type SearchResult = {
    file : Id;
    name : ?Text;
    meta : ?Text;
    pos : Nat;
  };

  public func search(q : Text) : async [SearchResult] {
    // to do
    [ ]
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
