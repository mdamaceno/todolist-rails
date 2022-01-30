FactoryBot.define do
  factory :task do
    sequence :title do |n|
      "Title #{n}"
    end
    sequence :description do |n|
      "Description #{n}"
    end
  end
end
