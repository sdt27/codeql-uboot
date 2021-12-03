import cpp

from FunctionCall func_call
where func_call.getTarget().getName() = "memcpy"
select func_call, "find all path that call memcpy"