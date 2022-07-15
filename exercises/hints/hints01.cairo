%lang starknet

# Cairo hints can be useful for delegating heavy computation.
# This pattern is at the very heart of Cairo: verification is much faster than computation.
# However, as hints are not part of the final Cairo bytecode, a malicious program may provide wrong results.
# You should always verify computations done inside hints.

# I AM DONE
# neoscript@gmail.com

# TODO: Compute the result of "x modulo n" inside a hint using python's `divmod`
# Don't forget to make sure the result is correct.

func modulo(x : felt, n : felt) -> (mod : felt):
    alloc_locals
    local quotient
    local remainder
    %{
        print(ids.x)
        print(ids.n)
        # TODO: Compute the quotient and remainder inside the hint
        (ids.quotient, ids.remainder) = divmod(ids.x, ids.n)
        print(ids.quotient)
        print(ids.remainder)
    %}
    # TODO: verify the result is correct
    assert n * quotient + remainder = x
    return (remainder)
end

# Do not change the test
@external
func test_modulo{syscall_ptr : felt*}():
    const NUM_TESTS = 19

    %{ import random %}
    tempvar count = NUM_TESTS

    loop:
    %{
        x = random.randint(2, 2**99)
        n = random.randint(2, 2**50)
        if x < n:
            x,n = n,x
    %}
    tempvar x = nondet %{ x %}
    tempvar n = nondet %{ n %}
    tempvar res = nondet %{ x % n %}

    let (mod) = modulo(x, n)
    assert res = mod
    tempvar count = count - 1
    jmp loop if count != 0

    return ()
end
