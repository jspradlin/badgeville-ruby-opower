describe BadgevilleBerlinGroupJsonFormat, ".decode" do

  it "should convert a string into a hash" do
    BadgevilleBerlinGroupJsonFormat.decode('{}').should == {}
  end

  it "should handle nils" do
    BadgevilleBerlinGroupJsonFormat.decode(nil).should == nil
  end

  context "with a single object" do

    it "should handle it" do
      @json_record_w_root =
        "{\"data\":{\"name\":\"visitor_username\",\"created_at\":\"2012-01-05T10:43:42-08:00\",\"email\":\"revised_visitor@emailserver.com\",\"_id\":\"4f05ef5ea768651b3500009f\"},\"paging\":null}"

      BadgevilleBerlinGroupJsonFormat.decode(@json_record_w_root).should ==
        {"name"=>"visitor_username", "created_at"=>"2012-01-05T10:43:42-08:00", "email"=>"revised_visitor@emailserver.com", "_id"=>"4f05ef5ea768651b3500009f"}
    end

    it "should handle when there's a nested key 'data'" do
      @json_w_2_keys_data =
        "{\"data\":{\"name\":\"visitor_username\",\"data\":\"value_of_nested_key_data\"},\"paging\":null}"

        BadgevilleBerlinGroupJsonFormat.decode(@json_w_2_keys_data).should == {"name"=>"visitor_username", "data" => "value_of_nested_key_data"}
    end

    it "should handle when there's no root key 'data'" do
      @json_record_without_root =
        "{\"name\":\"visitor_username\",\"created_at\":\"2012-01-05T10:43:42-08:00\",\"email\":\"revised_visitor@emailserver.com\",\"_id\":\"4f05ef5ea768651b3500009f\"}"

      BadgevilleBerlinGroupJsonFormat.decode(@json_record_without_root).should ==
        {"name"=>"visitor_username", "created_at"=>"2012-01-05T10:43:42-08:00", "email"=>"revised_visitor@emailserver.com", "_id"=>"4f05ef5ea768651b3500009f"}
    end

    it "should return entire hash when there is an empty hash at root key 'data'" do
        @json_record_data_empty =
          "{\"data\":{}, \"name\":\"visitor_username\",\"created_at\":\"2012-01-05T10:43:42-08:00\",\"email\":\"revised_visitor@emailserver.com\",\"_id\":\"4f05ef5ea768651b3500009f\"}"
        BadgevilleBerlinGroupJsonFormat.decode(@json_record_data_empty).should == {}
    end

  end

  context "with multiple objects" do
    it "should handle it" do
      @json_collection_w_root =
        '{"data":[{"name":"visitor1","_id":"4dfa6cbc888bae20b0000016"},{"name":"visitor2","_id":"4dfa8908888bae20b50000d1"}],"paging":{"current_page":1,"per_page":10}}'

      BadgevilleBerlinGroupJsonFormat.decode(@json_collection_w_root).should ==
        [ {"name" => "visitor1", "_id" => "4dfa6cbc888bae20b0000016", "rewards" => []},
          {"name" => "visitor2", "_id" => "4dfa8908888bae20b50000d1", "rewards" => []} ]
    end

    it "should handle when there's no root key 'data'" do
      @json_collection_without_root =
        '[{"name":"visitor1","_id":"4dfa6cbc888bae20b0000016"},{"name":"visitor2","_id":"4dfa8908888bae20b50000d1"}]'

      BadgevilleBerlinGroupJsonFormat.decode(@json_collection_without_root).should ==
        [ {"name" => "visitor1", "_id" => "4dfa6cbc888bae20b0000016"},
          {"name" => "visitor2", "_id" => "4dfa8908888bae20b50000d1"} ]
    end
  end

  context "rewards" do
    it "should handle it when there are none" do
      no_rewards = '{ "data": [ { "id": "2342", "name": "some_mission", "type": "collection", "image_url": null, "tip": "", "message": "", "privileges": "", "note": "", "display_priority": 0, "reward_definitions": [ ], "reward_image_url": null, "track_member": false, "adjustment": { }, "units_possible": { }, "progress": { "percent": 100, "earned": 2, "possible": 2 }, "last_reward": { }, "earned": 0, "rewards": { } } ], "paging": { "current_page": 1, "per_page": 10 }}'
      decoded_json = BadgevilleBerlinGroupJsonFormat.decode(no_rewards)
      decoded_json.first['rewards'].size.should == 0
    end

    it "should handle it when there is one" do
      one_rewards = '{ "data": [ { "id": "2342", "name": "some_mission", "type": "collection", "image_url": null, "tip": "", "message": "", "privileges": "", "note": "", "display_priority": 0, "reward_definitions": [ ], "reward_image_url": null, "track_member": false, "adjustment": { }, "units_possible": { }, "progress": { "percent": 100, "earned": 2, "possible": 2 }, "last_reward": { }, "earned": 0, "rewards": { "13523": { "name": "some_name", "created_at": "2012-07-26T19:22:46-07:00", "activity_id": "132", "id": "3423", "user_id": "2342", "site_id": "2342", "player_id": "3242", "definition": { "type": "rewarddefinition", "name": "reward_definition_name", "created_at": "2012-07-11T12:13:43-07:00", "assignable": true, "allow_duplicates": true, "components": "[]", "reward_template": { }, "tags": "", "site_id": "123", "image_url": null, "image_file_name": null, "data": { }, "_id": "213", "id": "234", "active": true, "hint": "", "message": null, "adjustment": { }, "active_start_at": null, "active_end_at": null, "performed_by": null, "reward_team_members": false }, "image": null, "tags": [ ], "status": null, "message": null, "history": null, "next_reward_id": null } } } ], "paging": { "current_page": 1, "per_page": 10 }}'
      decoded_json = BadgevilleBerlinGroupJsonFormat.decode(one_rewards)
      decoded_json.first['rewards'].size.should == 1
      decoded_json.first['rewards'].class.should == Array
    end

    it "should handle it when there is more than one" do
      multiple_rewards = '{ "data": [ { "id": "2342", "name": "some_mission", "type": "collection", "image_url": null, "tip": "", "message": "", "privileges": "", "note": "", "display_priority": 0, "reward_definitions": [ ], "reward_image_url": null, "track_member": false, "adjustment": { }, "units_possible": { }, "progress": { "percent": 100, "earned": 2, "possible": 2 }, "last_reward": { }, "earned": 0, "rewards": { "5124": { "name": "some_other_reward", "created_at": "2012-07-26T19:21:52-07:00", "activity_id": "1234", "id": "12341", "user_id": "12", "site_id": "12", "player_id": "123", "definition": { "type": "rewarddefinition", "name": "some_other_reward_definition", "created_at": "2012-07-18T07:22:45-07:00", "assignable": true, "allow_duplicates": true, "components": "[]", "reward_template": { }, "tags": "", "site_id": "12", "image_url": null, "image_file_name": null, "data": { }, "_id": "423", "id": "1231", "active": true, "hint": "", "message": null, "adjustment": { }, "active_start_at": null, "active_end_at": null, "performed_by": null, "reward_team_members": false }, "image": null, "tags": [ ], "status": null, "message": null, "history": null, "next_reward_id": null }, "13523": { "name": "some_name", "created_at": "2012-07-26T19:22:46-07:00", "activity_id": "132", "id": "3423", "user_id": "2342", "site_id": "2342", "player_id": "3242", "definition": { "type": "rewarddefinition", "name": "reward_definition_name", "created_at": "2012-07-11T12:13:43-07:00", "assignable": true, "allow_duplicates": true, "components": "[]", "reward_template": { }, "tags": "", "site_id": "123", "image_url": null, "image_file_name": null, "data": { }, "_id": "213", "id": "234", "active": true, "hint": "", "message": null, "adjustment": { }, "active_start_at": null, "active_end_at": null, "performed_by": null, "reward_team_members": false }, "image": null, "tags": [ ], "status": null, "message": null, "history": null, "next_reward_id": null } } } ], "paging": { "current_page": 1, "per_page": 10 }}'
      decoded_json = BadgevilleBerlinGroupJsonFormat.decode(multiple_rewards)
      decoded_json.first['rewards'].size.should == 2
      decoded_json.first['rewards'].class.should == Array
    end
  end

end