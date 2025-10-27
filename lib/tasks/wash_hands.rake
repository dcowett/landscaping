task wash_hands: [ :wet, :soap, :wash, :rinse, :dry ] do
  puts "Task is done, your hands are clean"
end

task :wet do
  puts "Wet your hands"
end

task :soap do
  puts "Soap your hands"
end

task :wash do
  puts "Wash your hands"
end

task :rinse do
  puts "Rinse your hands"
end

task :dry do
  puts "Dry your hands"
end
