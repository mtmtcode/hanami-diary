RSpec.describe Web::Controllers::Entries::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:repository) { EntryRepository.new }

  before do
    repository.clear
  end

  it "is successful" do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it "returns entries in descending order by date" do
    repository.create(date: Date.new(2021, 10, 1), body: "test entry")
    repository.create(date: Date.new(2021, 10, 2), body: "test entry")

    response = action.call(params)
    results = JSON.load(response[2][0])
    expect(results.length).to eq(2)
    expect(results.first["date"]).to eq("2021-10-02")
    expect(results.last["date"]).to eq("2021-10-01")
  end

  it "returns up to 50 entries" do
    begin_ = Date.new(2021, 1, 1)
    (0..50).each do |i|
      date = begin_ + i
      repository.create(date: date, body: "test entry")
    end

    response = action.call(params)

    results = JSON.load(response[2][0])
    expect(results.length).to eq(50)
  end

  context "with page specified" do
    let(:params) { Hash[page: 2] }

    it "returns results in the specified page" do
      begin_ = Date.new(2021, 1, 1)
      (0..50).each do |i|
        date = begin_ + i
        repository.create(date: date, body: "test entry")
      end

      response = action.call(params)

      results = JSON.load(response[2][0])
      expect(results.length).to eq(1)
      expect(results[0]["date"]).to eq(repository.first.date.iso8601)
    end
  end

  context "with year and month specified" do
    let(:params) { Hash[year: 2021, month: 10] }

    it "is successful" do
      response = action.call(params)
      expect(response[0]).to eq(200)
    end

    it "filters results by month" do
      repository.create(date: Date.new(2021, 9, 30), body: "test entry")
      repository.create(date: Date.new(2021, 10, 1), body: "test entry")
      repository.create(date: Date.new(2021, 10, 31), body: "test entry")
      repository.create(date: Date.new(2021, 11, 1), body: "test entry")

      response = action.call(params)

      results = JSON.load(response[2][0])
      expect(results.length).to eq(2)
      expect(results.first["date"]).to eq("2021-10-31")
      expect(results.last["date"]).to eq("2021-10-01")
    end
  end

  context "with invalid page" do
    let(:params) { Hash[page: 0] }

    it "returns 422" do
      response = action.call(params)
      expect(response[0]).to eq(422)
    end
  end
end
