describe BadgevilleBerlinGroupJsonFormat, ".decode" do

  it "should convert a string into a hash" do
    BadgevilleBerlinGroupJsonFormat.decode('{}').should == {}
  end

  it "should handle nils" do
    BadgevilleBerlinGroupJsonFormat.decode(nil).should == nil
  end

  context "with multiple objects" do
    it "should handle it" do
      @json_collection_w_root =
        '{"data":[{"name":"visitor1","_id":"4dfa6cbc888bae20b0000016"},{"name":"visitor2","_id":"4dfa8908888bae20b50000d1"}],"paging":{"current_page":1,"per_page":10}}'

      BadgevilleBerlinGroupJsonFormat.decode(@json_collection_w_root).should ==
        [ {"name" => "visitor1", "_id" => "4dfa6cbc888bae20b0000016"},
          {"name" => "visitor2", "_id" => "4dfa8908888bae20b50000d1"} ]
    end

    it "should handle when there's no root key 'data'" do
      @json_collection_without_root =
        '[{"name":"visitor1","_id":"4dfa6cbc888bae20b0000016"},{"name":"visitor2","_id":"4dfa8908888bae20b50000d1"}]'

      BadgevilleBerlinGroupJsonFormat.decode(@json_collection_without_root).should ==
        [ {"name" => "visitor1", "_id" => "4dfa6cbc888bae20b0000016"},
          {"name" => "visitor2", "_id" => "4dfa8908888bae20b50000d1"} ]
    end
  end

end