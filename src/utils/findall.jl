import Base.findall

#=
function findall(f, a::Array{T, N}) where {T, N}
    j = 1
    b = Vector{Int}(undef, length(a))
    @inbounds for i in eachindex(a)
        @inbounds if f(a[i])
            b[j] = i
            j += 1
        end
    end
    resize!(b, j-1)
    sizehint!(b, length(b))
    return b
end
=#

function findall(t::Union{AbstractString,Regex}, s::AbstractString; overlap::Bool=false)
    found = UnitRange{Int}[]
    i, e = firstindex(s), lastindex(s)
    while true
        r = findnext(t, s, i)
        isnothing(r) && return found
        push!(found, r)
        j = overlap || isempty(r) ? first(r) : last(r)
        j > e && return found
        @inbounds i = nextind(s, j)
    end
end

