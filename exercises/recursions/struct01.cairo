%lang starknet

# Structs are nothing more than a continuous list of felts in memory. So are arrays.
#
# In other words, a felt* can point to an element of an array, but also
# to an element of a struct. It is therefore possible to access the next element of a
# struct by incrementing the pointer, just like with arrays.
#
# It is also worth noting that a struct pointer implicitely casts to a felt pointer
# (eg. Foo* is automatically casted to felt*)


# I am looking for cairo jobs, typescript and react is also ok.
# mailto: neoscript@gmail.com

struct Vector2D:
    member x : felt
    member y : felt
end

struct Vector3D:
    member x : felt
    member y : felt
    member z : felt
end

# Returns the squared magnitude of a vector.
# Examples:
#   - the squared magnitude of a 2D vector (x,y) is x * x + y * y.
#   - the squared magnitude of a 3D vector (x,y,z) is x * x + y * y + z * z.
func squared_magnitude(struct_value : felt*, struct_size : felt) -> (res : felt):
    # FILL ME
    alloc_locals
    if struct_size == 2:
        local v2d : Vector2D = [cast(struct_value, Vector2D*)]
        return (v2d.x * v2d.x + v2d.y * v2d.y)
    else:
        local v3d : Vector3D = [cast(struct_value, Vector3D*)]
        return (v3d.x * v3d.x + v3d.y * v3d.y + v3d.z * v3d.z)
    end
end
func squared_magnitude2(struct_value : felt*, struct_size : felt) -> (res : felt):
    # FILL ME
    alloc_locals
    if struct_size == 2:
        return ([struct_value] * [struct_value] + [struct_value + 1] * [struct_value + 1])
    else:
        return (
            [struct_value] * [struct_value] + [struct_value + 1] * [struct_value + 1] + [struct_value + 2] * [struct_value + 2],
        )
    end
end
# TESTS #

@external
func test_squared_magnitude{range_check_ptr : felt}():
    tempvar vector2D : Vector2D* = new Vector2D(x=4, y=7)
    let (res) = squared_magnitude(vector2D, Vector2D.SIZE)
    assert res = 4 * 4 + 7 * 7

    tempvar vector3D : Vector3D* = new Vector3D(x=8, y=2, z=1)
    let (res) = squared_magnitude(vector3D, Vector3D.SIZE)
    assert res = 8 * 8 + 2 * 2 + 1 * 1

    return ()
end
