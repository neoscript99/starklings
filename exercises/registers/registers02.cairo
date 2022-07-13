%lang starknet
from starkware.cairo.common.math_cmp import is_le

# Worked in Cairo Playground, has error here: Missing memory cells for range_check.
# I am looking for cairo jobs, good at typescript and react also.
# mailto: neoscript@gmail.com

# TODO
# Rewrite those functions with a high level syntax
@external
func sum_array(array_len : felt, array : felt*) -> (sum : felt):
    # [ap] = [fp - 4]; ap++
    # [ap] = [fp - 3]; ap++
    # [ap] = 0; ap++
    # call rec_sum_array
    # ret
    let (sum) = rec_sum_array(array_len, array, 0)
    return (sum)
end

func rec_sum_array(array_len : felt, array : felt*, sum : felt) -> (sum : felt):
    # jmp continue if [fp - 5] != 0
    if array_len == 0:
        return (sum)
    end
    # stop:
    # [ap] = [fp - 3]; ap++
    # jmp done

    # continue:
    # [ap] = [[fp - 4]]; ap++
    # [ap] = [fp - 5] - 1; ap++
    # [ap] = [fp - 4] + 1; ap++
    # [ap] = [ap - 3] + [fp - 3]; ap++
    # call rec_sum_array
    tempvar v = [array]
    return rec_sum_array(array_len - 1, array + 1, sum + v)
    # done:
    # ret
end

# TODO
# Rewrite this function with a low level syntax
# It's possible to do it with only registers, labels and conditional jump. No reference or localvar
@external
func max{range_check_ptr}(a : felt, b : felt) -> (max : felt):
    # range_check_ptr
    [ap] = [fp - 5]; ap++
    [ap] = [fp - 4]; ap++
    [ap] = [fp - 3]; ap++
    call is_le
    # is_le 返回值 本来在ap - 1，设置range_check_ptr后再 ap - 2
    jmp big_than if [ap - 1] != 0
    # range_check_ptr 返回值
    [ap] = [ap - 2]; ap++
    [ap] = [fp - 4]; ap++
    jmp done

    big_than:
    # range_check_ptr 返回值
    [ap] = [ap - 2]; ap++
    [ap] = [fp - 3]; ap++

    done:
    ret
end
#########
# TESTS #
#########

from starkware.cairo.common.alloc import alloc

@external
func test_max{range_check_ptr}():
    let (m) = max(21, 42)
    assert m = 42
    let (m) = max(42, 21)
    assert m = 42
    return ()
end

@external
func test_sum():
    let (array) = alloc()
    assert array[0] = 1
    assert array[1] = 2
    assert array[2] = 3
    assert array[3] = 4
    assert array[4] = 5
    assert array[5] = 6
    assert array[6] = 7
    assert array[7] = 8
    assert array[8] = 9
    assert array[9] = 10

    let (s) = sum_array(10, array)
    assert s = 55

    return ()
end
