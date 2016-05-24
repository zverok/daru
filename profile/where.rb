require_relative '_base'

df = Daru::DataFrame.new({
  a: [1,2,3,4,5,6]*1000,
  b: ['a','b','c','d','e','f']*1000,
  c: [11,22,33,44,55,66]*1000
}, index: (1..6000).to_a.shuffle)

__profile__ do
  df.where(df[:a].eq(2) | df[:c].eq(55))
end
