RSpec.describe EntryRepository, type: :repository do
  let(:repository) { EntryRepository.new }

  before do
    repository.clear
  end

  describe "#list_by_desc_date" do
    it "returns a list of entries in descendent order by date" do
      repository.create(date: Date.new(2021, 10, 9), body: "test entry1")
      repository.create(date: Date.new(2021, 10, 10), body: "test entry2")

      entries = repository.list_by_desc_date
      expect(entries[0].date).to eq(Date.new(2021, 10, 10))
      expect(entries[1].date).to eq(Date.new(2021, 10, 9))
    end

    it "can limit the number of entries in the result" do
      repository.create(date: Date.new(2021, 10, 9), body: "test entry1")
      repository.create(date: Date.new(2021, 10, 10), body: "test entry2")

      entries = repository.list_by_desc_date(limit: 1)
      expect(entries.length).to eq(1)
    end

    it "can filter entries by month" do
      repository.create(date: Date.new(2021, 9, 30), body: "test entry1")
      repository.create(date: Date.new(2021, 10, 1), body: "test entry2")
      repository.create(date: Date.new(2021, 10, 31), body: "test entry3")
      repository.create(date: Date.new(2021, 11, 1), body: "test entry4")

      entries = repository.list_by_desc_date(year: 2021, month: 10)
      expect(entries.length).to eq(2)
      expect(entries.map(&:date).map(&:month)).to all(eq(10))
    end

    it "should be called with year and month both specified or both unspecified" do
      expect { repository.list_by_desc_date(year: 2021) }.to raise_error
    end
  end
end
