-- unpack multival 
-- 1: using a table
-- 1.1: use select
-- 2: using fn signatures
-- 2.1: recursion
local function two_vals() return "first", "second" end
local tab = {two_vals()}
print(tab[1], tab[2])

local function multi_first(x, ...) return x end
print(multi_first(1, 2, 3))

local function multi_rest(x, ...) return ... end
print(multi_rest(1, 2, 3))

print(select(2, 10, 20, 30))

local function inc_vals(first, ...)
  if first then
    return first + 1, inc_vals(...)
  end
end

print(inc_vals(1, 2, 3))

local function pack_multi(...)
  return {...}
end

print(#pack_multi(10, 20, 30))

local function get_end_multi(...)
  local count = select('#', ...)
  return select(count, ...)
end

print(get_end_multi(1, 2, 3, 4, 100))

-- dynamically scoped variables are dependent on the runtime

local function assign_vararg(...)
  -- upacking not assigning!
  local x = ...
  return x
end

print(assign_vararg(1, 2, 3, 4))

local function vararg_closure(...)
  return function()
    return ...
  end
end

-- cannot use '...' outside a vararg function
-- '...' is dynamically scoped to the function where it's defined
print(assign_vararg(1, 2, 3, 4))

local function vararg_closure_2(...)
  -- pass vararg as argument 
  return function(...)
    return ...
  end
end

print(1, 2, 3, 4)

local function multi_vals()
  return 1, 2, 3
end

print(multi_vals())
print(#{multi_vals()})

-- multival cutoff
-- vararg is expanded only if it's the last argument
print(multi_vals(), 4, 5)
print(#{multi_vals(), 4, 5})

-- key set to nil and a non-existent key are indistinguishable
-- no undefined 

local y = {nil, nil, nil}

print(#y)

local function multival_len(...) return select("#", ...) end

-- select is weird, counts nils
print(multival_len(nil, nil, nil))

print(select("#", print("a"), print("b"), print("c")))

-- check whether to unpack or assing
-- select("#", ...)

-- vararg breaks tail elimination
local function myrange(acc, n)
  if n < 1 then return
  elseif n == 1 then return acc
  else return acc, myrange(acc+1, n-1)
  end
end

local function range(n)
  if n < 1 then error("only positive") end
  return myrange(1, n)
end

print(range(3))
print(#{range(10)})
-- stack overflow
-- return values must be collected before returning them
-- stack frames can't be eliminated 
print(#{range(1000 * 1000)})

-- tables support tail elimination
local function myrange(tab, acc, n)
  if n < 1 then return tab
  else
  tab[acc] = acc
  return myrange(tab, acc+1, n-1)
  end
end

local function range(n)
  if n < 1 then error("only positive") end
  return myrange({}, 1, n)
end

print(#range(1000 * 1000))

-- varargs have cap on size
-- even more restricted size when calling a function
-- VARARGS != TABLE


-- SUMMARY
-- Multivals cannot be assigned to a variable, unless wrapped in table ltieral
-- Varargs is dynamically scoped to it's function
-- Multivals are cut off, when not at the end of the arg list
-- Multivals len counts nils
-- Multivals break tail elimination
-- Unpacking too big varargs errors out
-- Returning too many multivals erros out
--
-- Varargs is anotehr data structure, but just a BAD ONE!
