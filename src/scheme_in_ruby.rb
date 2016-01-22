def _eval(exp)
  if not list?(exp)
    if immediate_val?(exp)
      exp
    else
      lookup_primitive_fun(exp)
    end
  else
    fun = _eval(car(exp))
    args = eval_list(cdr(exp))
    apply(fun, args)
  end
end
