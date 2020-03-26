# N-dimensional face with normal in the positive D direction
struct DummyFace{N,D} <: AbstractFace{N,D} end

struct Face{N,D} <: AbstractFace{N,D}
    cells::Tuple{AbstractTree{N},AbstractTree{N}}
end
# Initialize a face, here Val indicates the side (1 or 2) relative to cell of this face
Face(cell::AbstractTree{N}, other_cell::AbstractTree{N}, ::Val{D}, ::Val{2}) where {N,D} = Face{N,D}((cell, other_cell))
Face(cell::AbstractTree{N}, other_cell::AbstractTree{N}, ::Val{D}, ::Val{1}) where {N,D} = Face{N,D}((other_cell, cell))

@inline at_boundary(face::Face) = count(initialized.(face.cells)) == 1
@inline at_boundary(face::AbstractFace) = false
@inline at_refinement(face::Face) = all(initialized.(face.cells)) && face.cells[1].level != face.cells[2].level
@inline at_refinement(face::AbstractFace) = false
@inline regular(face::Face) = all(initialized.(face.cells)) && face.cells[1].level == face.cells[2].level
@inline regular(face::AbstractFace) = false

@inline active(face::Face) = all(active.(face.cells)) || (at_boundary(face) && count(active.(face.cells)) == 1)
@inline active(face::AbstractFace) = false

@inline initialized(face::AbstractFace) = false
@inline initialized(face::Face) = true

@inline level(face::Face) = regular(face) ? max(face.cells[1].level, face.cells[2].level) : (initialized(face.cells[1]) ? face.cells[1].level : face.cells[2].level)
