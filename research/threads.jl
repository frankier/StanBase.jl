# Thread based scheduling for StanBase?

function intensive_computation()
    started = time_ns()
    while time_ns() - started < 1_000_000_000
    end
end

@show Threads.nthreads()
let t0 = time_ns()
    tasks = [Threads.@spawn(intensive_computation()) for _ in 1:Threads.nthreads()]
    t1 = time_ns()
    print("all ")
    t2 = time_ns()
    println("spawned")
    t3 = time_ns()
    foreach(wait, tasks)
    t4 = time_ns()
    @show (t1 - t0) / 1_000_000
    @show (t2 - t1) / 1_000_000
    @show (t3 - t2) / 1_000_000
    @show (t4 - t3) / 1_000_000
end

