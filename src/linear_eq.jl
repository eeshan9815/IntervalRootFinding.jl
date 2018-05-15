using IntervalArithmetic
"""
Preconditions the matrix A and b with the inverse of mid(A)
"""
function preconditioner{T}(A::Matrix{Interval{T}}, b::Array{Interval{T}})

    Aᶜ = mid.(A)
    B = inv(Aᶜ)

    return B*A, B*b

end

function gauss_seidel_interval{T}(A::Matrix{Interval{T}}, b::Array{Interval{T}}; precondition=true, maxiter=100)

    n = size(A, 1)
    x = fill(-1e16..1e16, n)
    gauss_seidel_interval!(x, A, b, precondition=precondition, maxiter=maxiter)
    return x
end
"""
Iteratively solves the system of interval linear
equations and returns the solution set. Uses the
Gauss-Seidel method (Hansen-Sengupta version) to solve the system.
Keyword `precondition` to turn preconditioning off.
Eldon Hansen and G. William Walster : Global Optimization Using Interval Analysis - Chapter 5 - Page 115
"""
function gauss_seidel_interval!{T}(x::Array{Interval{T}}, A::Matrix{Interval{T}}, b::Array{Interval{T}}; precondition=true, maxiter=100)

    precondition && ((M, r) = preconditioner(A, b))

    n = size(A, 1)

    for iter in 1:maxiter
        for i in 1:n
            Y = r[i]
            for j in 1:n
                (i == j) || (Y -= M[i, j] * x[j])
            end
            Z = extended_div(Y, M[i, i])
            x[i] = hull((x[i] ∩ Z[1]), x[i] ∩ Z[2])
        end
    end
    x
end

function preconditioner_static{T, N}(A::MMatrix{N, N, Interval{T}}, b::MVector{N, Interval{T}})

    Aᶜ = mid.(A)
    B = inv(Aᶜ)

    return B*A, B*b

end


function gauss_seidel_interval_static{T, N}(A::MMatrix{N, N, Interval{T}}, b::MVector{N, Interval{T}}; precondition=true, maxiter=100)

    n = size(A, 1)
    x = @MVector fill(-1e16..1e16, n)
    gauss_seidel_interval_static!(x, A, b, precondition=precondition, maxiter=maxiter)
    return x
end

"""
Iteratively solves the system of interval linear
equations and returns the solution set. Uses the
Gauss-Seidel method (Hansen-Sengupta version) to solve the system.
Keyword `precondition` to turn preconditioning off.
Eldon Hansen and G. William Walster : Global Optimization Using Interval Analysis - Chapter 5 - Page 115
"""
function gauss_seidel_interval_static!{T, N}(x::MVector{N, Interval{T}}, A::MMatrix{N, N, Interval{T}}, b::MVector{N, Interval{T}}; precondition=true, maxiter=100)

    precondition && ((M, r) = preconditioner_static(A, b))

    n = size(A, 1)

    for iter in 1:maxiter
        for i in 1:n
            Y = r[i]
            for j in 1:n
                (i == j) || (Y -= M[i, j] * x[j])
            end
            Z = extended_div(Y, M[i, i])
            x[i] = hull((x[i] ∩ Z[1]), x[i] ∩ Z[2])
        end
    end
    x
end

function preconditioner_static1{T, N}(A::SMatrix{N, N, Interval{T}}, b::SVector{N, Interval{T}})

    Aᶜ = mid.(A)
    B = inv(Aᶜ)

    return B*A, B*b

end


function gauss_seidel_interval_static1{T, N}(A::SMatrix{N, N, Interval{T}}, b::SVector{N, Interval{T}}; precondition=true, maxiter=100)

    n = size(A, 1)
    x = @MVector fill(-1e16..1e16, n)
    gauss_seidel_interval_static1!(x, A, b, precondition=precondition, maxiter=maxiter)
    return x
end

"""
Iteratively solves the system of interval linear
equations and returns the solution set. Uses the
Gauss-Seidel method (Hansen-Sengupta version) to solve the system.
Keyword `precondition` to turn preconditioning off.
Eldon Hansen and G. William Walster : Global Optimization Using Interval Analysis - Chapter 5 - Page 115
"""
function gauss_seidel_interval_static1!{T, N}(x::MVector{N, Interval{T}}, A::SMatrix{N, N, Interval{T}}, b::SVector{N, Interval{T}}; precondition=true, maxiter=100)

    precondition && ((M, r) = preconditioner_static1(A, b))

    n = size(A, 1)

    for iter in 1:maxiter
        for i in 1:n
            Y = r[i]
            for j in 1:n
                (i == j) || (Y -= M[i, j] * x[j])
            end
            Z = extended_div(Y, M[i, i])
            x[i] = hull((x[i] ∩ Z[1]), x[i] ∩ Z[2])
        end
    end
    x
end