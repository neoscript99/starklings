%lang starknet

# Getting pointer as function arguments let us modify the values at the memory address of the pointer
# ...or not! Cairo memory is immutable. Therefore you cannot just update a memory cell.

# I AM DONE

# TODO: Update the square function – you can change the body and the signature –
# to make it achieve the desired result: returning an array
# with the squared values of the input array.

from starkware.cairo.common.alloc import alloc

func square(array : felt*, array_len : felt) -> (new_array : felt*):
    alloc_locals
    let (local new_array : felt*) = alloc()

    square_copy(new_array, array, array_len)
    return (new_array)
end
func square_copy(new_array : felt*, array : felt*, array_len : felt):
    if array_len == 0:
        return ()
    end

    assert [new_array] = array[0] * array[0]

    return square_copy(new_array + 1, array + 1, array_len - 1)
end

# You can update the test if the function signature changes.
@external
func test_square{syscall_ptr : felt*}():
    alloc_locals
    let (local array : felt*) = alloc()

    assert [array] = 1
    assert [array + 1] = 2
    assert [array + 2] = 3
    assert [array + 3] = 4

    let (local array) = square(array, 4)

    assert [array] = 1
    assert [array + 1] = 4
    assert [array + 2] = 9
    assert [array + 3] = 16

    return ()
end
