require 'box_packer'
require 'pry'
#require "/data/sellegit/box_packer/box_packer.rb"
describe '.pack' do
  it do
    packings = BoxPacker.pack(
      container: { dimensions: [15, 20, 13], weight_limit: 50 },
      items: [
        { dimensions: [2, 3, 5], weight: 47 },
        { dimensions: [2, 3, 5], weight: 47 },
        { dimensions: [3, 3, 1], weight: 24 },
        { dimensions: [1, 1, 4], weight: 7 },
      ]
    )

    expect(packings.length).to eql(3)
    expect(packings[0][:weight]).to eql(47.0)
    expect(packings[0][:placements].length).to eql(1)
    expect(packings[0][:placements][0][:dimensions]).to eql([5, 3, 2])
    expect(packings[0][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[1][:weight]).to eql(47.0)
    expect(packings[1][:placements].length).to eql(1)
    expect(packings[1][:placements][0][:dimensions]).to eql([5, 3, 2])
    expect(packings[1][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[2][:weight]).to eql(31.0)
    expect(packings[2][:placements].length).to eql(2)
    expect(packings[2][:placements][0][:dimensions]).to eql([3, 3, 1])
    expect(packings[2][:placements][0][:position]).to eql([0, 0, 0])
    expect(packings[2][:placements][1][:dimensions]).to eql([4, 1, 1])
    expect(packings[2][:placements][1][:position]).to eql([3, 0, 0])
  end

  it 'no weight given' do
    packings = BoxPacker.pack(
      container: { dimensions: [13, 15, 20] },
      items: [
        { dimensions: [2, 3, 5] },
        { dimensions: [2, 3, 5] },
        { dimensions: [3, 3, 1] },
        { dimensions: [1, 1, 4] },
      ]
    )
    expect(packings.length).to eql(1)
    expect(packings[0][:weight]).to eql(0.0)
    expect(packings[0][:placements].length).to eql(4)
  end

  it 'max size for one packing' do
    20.times.each do |i|
      items = 
        [
          { dimensions: [(Random.rand(5) + 1) * 10, (Random.rand(5) + 1) * 10, (Random.rand(5) + 1) * 10] },
          { dimensions: [(Random.rand(5) + 1) * 10, (Random.rand(5) + 1) * 10, (Random.rand(5) + 1) * 10] },
      ]
        packings = BoxPacker.pack(
          container: { dimensions: [1000, 1000, 1000], weight_limit: 50 },
          items: items
        )
        depth = 0
        width = 0
        height = 0
        items.each do |item|
          depth += item[:dimensions][0]
          width += item[:dimensions][1]
          height += item[:dimensions][2]
          puts "* item: " + [item[:dimensions][0], item[:dimensions][1], item[:dimensions][2]].sort.reverse.join(', ')
        end
        new_dim = BoxPacker.get_packing_size(packings.first)
        new_volume = new_dim[0] * new_dim[1] * new_dim[2]
        old_volume = depth * width * height
        puts "+ new box packer: " + new_dim.join(', ')
        puts "- old box packer: " + [depth, width, height].sort.reverse.join(', ')
        puts "> save volume: " + ('%.2f' % ((old_volume.to_f - new_volume) / old_volume * 100))
        puts ""

        expect(packings.length).to eql(1)
    end
  end

end
