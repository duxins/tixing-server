namespace :import do
  desc 'Import sounds'
  task :sounds => :environment do

    sounds = [
        {id: 1, name: 'tixing',   label: '默认'},
        {id: 2, name: 'ding',     label: '叮'},
        {id: 3, name: 'elevator', label: '电梯'},
        {id: 4, name: 'dingdong', label: '叮咚'},
        {id: 5, name: 'piano',    label: '钢琴'},
        {id: 6, name: 'spring',   label: '弹簧'},
        {id: 7, name: 'alarm',    label: '警报'},
    ]

    sounds.each do |sound|
      Sound.find_or_create_by(id: sound[:id]).update(sound)
    end

  end
end