# The server should first be started with:
# `docker run -p 8000:80 kennethreitz/httpbin`
@use "github.com/jkroso/Rutherford.jl/test.jl" testset @test @catch
@use "github.com/jkroso/parse-json.jl"
@use "." GET Session

testset("errors based on response status code") do
  @test nothing != @catch GET(":8000/status/400")
end

testset("redirects") do
  @test GET(":8000/redirect/3").status == 200
  @test GET(":8000/relative-redirect/3").status == 200
  @test GET(":8000/absolute-redirect/3").status == 200
end

testset("Content-Encoding") do
  @test parse(GET(":8000/gzip")) isa Dict
  @test parse(GET(":8000/deflate")) isa Dict
end

testset("Session") do
  s = Session(":8000")
  @test parse(GET(s, "/cookies/set?a=1")) == Dict("cookies"=>Dict("a"=>"1"))
  @test parse(GET(s, "/cookies/set?b=2")) == Dict("cookies"=>Dict("a"=>"1","b"=>"2"))
end
