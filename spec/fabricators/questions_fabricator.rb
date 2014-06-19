Fabricator(:question) do
  description  { Faker::Lorem.paragraph }
  title { ["How do I build a WordPress site?", "How much do logos typically cost?", 
    "How long does it take to build a website?", "What hosting provider should I use?", 
    "How do I learn to code?"].sample}
end