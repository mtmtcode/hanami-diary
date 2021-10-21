RSpec.describe Web::Controllers::Templates::Create, type: :action do
  let(:action) { described_class.new }
  let(:repository) { TemplateRepository.new }

  before do
    repository.clear
  end

  context "with valid params" do
    let(:params) { Hash[title: "test title", body: "test body"] }

    it "returns 201" do
      response = action.call(params)
      expect(response[0]).to eq 201
    end

    it "creates a new template" do
      action.call(params)

      created = repository.last
      expect(created.title).to eq(params[:title])
      expect(created.body).to eq(params[:body])
    end

    it "returns a created template" do
      response = action.call(params)
      result = JSON.load(response[2][0])
      created = repository.last
      expect(result["title"]).to eq(created.title)
      expect(result["body"]).to eq(created.body)
    end
  end

  context "with parameter empty" do
    let(:params) { Hash[] }

    it "returns 422" do
      response = action.call(params)
      expect(response[0]).to eq 422
    end
  end
end
