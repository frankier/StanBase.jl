import Base.findall

"""

Replacement for `findall` for Julia versions < 1.3

$(SIGNATURES)

# Extended help

Exported if Julia VERSION.minor < 3
"""
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

export
    findall
