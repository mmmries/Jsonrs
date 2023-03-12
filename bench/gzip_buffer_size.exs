# two sample JSON files from:
# 10mb sample https://raw.githubusercontent.com/TheProfs/socket-mem-leak/master/10mb-sample.json
# 100mb sample 100mb sample from https://raw.githubusercontent.com/seductiveapps/largeJSON/master/100mb.json
# stored as gzip to minimize the git repo impact
#m10 = File.read!("tmp/10mb-sample.json.gz") |> :zlib.gunzip() |> Jason.decode!()
m100 = File.read!("tmp/100mb-sample.json.gz") |> :zlib.gunzip() |> Jason.decode!()

Benchee.run(
  %{
    "encode_gzip" => fn {input, buffer_size} -> Jsonrs.encode_gzip!(input, buffer_size) end,
  },
  inputs: %{
    "100m x 1k" => {m100, 1024},
    "100m x 10k" => {m100, 10 * 1024},
    "100m x 100k" => {m100, 100 * 1024},
    "100m x 1mb" => {m100, 1024 * 1024},
    "100m x 10mb" => {m100, 10 * 1024 * 1024}
  },
  time: 60,
  memory_time: 3,
  formatters: [
    Benchee.Formatters.HTML
  ]
)
