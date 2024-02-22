require 'rails_helper'

RSpec.describe "ApiController", type: :request do
  before do
    Node.create(id: 125, parent_id: 130)
    Node.create(id: 130)
    Node.create(id: 2820230, parent_id: 125)
    Node.create(id: 4430546, parent_id: 125)
    Node.create(id: 5497637, parent_id: 4430546)
  end

  describe "GET /common_ancestor" do
    context "when using data set with one root node" do
      it 'returns the lowest common ancestor id' do
        get "/common_ancestor", params: { a: 5497637, b: 2820230 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 130, "lowest_common_ancestor" => 125, "depth" => 2 })
      end

      it 'returns the lowest common ancestor id' do
        get "/common_ancestor", params: { a: 5497637, b: 4430546 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 130, "lowest_common_ancestor" => 4430546, "depth" => 3 })
      end

      it 'returns the root id if it is the same as the common ancestor id' do
        get "/common_ancestor", params: { a: 5497637, b: 130 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 130, "lowest_common_ancestor" => 130, "depth" => 1 })
      end

      it 'returns nil in all fields if there is no common match' do
        get "/common_ancestor", params: { a: 9, b: 4430546 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => nil, "lowest_common_ancestor" => nil, "depth" => nil })
      end

      it 'it returns itself if a==b' do
        get "/common_ancestor", params: { a: 4430546, b: 4430546 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 130, "lowest_common_ancestor" => 4430546, "depth" => 3 })
      end
    end

    context "when using data set with multiple root nodes" do
      before do
        # second data set to replicate having multiple root nodes
        Node.create(id: 126, parent_id: 131)
        Node.create(id: 131)
        Node.create(id: 2820231, parent_id: 126)
        Node.create(id: 4430547, parent_id: 126)
        Node.create(id: 5497638, parent_id: 4430547)
      end

      it 'returns the lowest common ancestor id' do
        get "/common_ancestor", params: { a: 5497638, b: 2820231 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 131, "lowest_common_ancestor" => 126, "depth" => 2 })
      end

      it 'returns the lowest common ancestor id' do
        get "/common_ancestor", params: { a: 5497638, b: 131 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 131, "lowest_common_ancestor" => 131, "depth" => 1 })
      end

      it 'returns the root id if it is the same as the common ancestor id' do
        get "/common_ancestor", params: { a: 5497638, b: 4430547 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 131, "lowest_common_ancestor" => 4430547, "depth" => 3 })
      end

      it 'returns nil in all fields if there is no common match' do
        get "/common_ancestor", params: { a: 2820230, b: 4430547 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => nil, "lowest_common_ancestor" => nil, "depth" => nil })
      end

      it 'it returns itself if a==b' do
        get "/common_ancestor", params: { a: 4430547, b: 4430547 }
        expect(JSON.parse(response.body)).to eq({ "root_id" => 131, "lowest_common_ancestor" => 4430547, "depth" => 3 })
      end
    end
  end

  describe "GET /birds" do
    before do
      Node.create(id: 126, parent_id: 131)
      Node.create(id: 131)
      Node.create(id: 2820231, parent_id: 126)
      Node.create(id: 4430547, parent_id: 126)
      Node.create(id: 5497638, parent_id: 4430547)
      Bird.create(id: 1, node_id: 130)
      Bird.create(id: 2, node_id: 5497637)
      Bird.create(id: 3, node_id: 131)
      Bird.create(id: 4, node_id: 5497638)
    end

    it 'returns the ids of birds that belong to the nodes provided' do
      get "/birds", params: { node_ids: [5497637] }
      expect(JSON.parse(response.body)).to eq([2])
    end

    it 'returns the ids of birds that belong to descendents of the nodes provided' do
      get "/birds", params: { node_ids: [130] }
      expect(JSON.parse(response.body)).to eq([1, 2])
    end

    it 'returns the ids of birds that belong to one of the nodes provided' do
      get "/birds", params: { node_ids: [5497637, 5497638] }
      expect(JSON.parse(response.body)).to eq([2])
    end

    it 'returns the ids of birds that belong to descendents to one of the nodes provided' do
      get "/birds", params: { node_ids: [130, 131] }
      expect(JSON.parse(response.body)).to eq([1, 2])
    end
  end
end
