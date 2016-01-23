### evaluation ###
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

def list?(exp)
  exp.is_a?(Array)
end

def lookup_primitive_fun(exp)
  $primitive_fun_env[exp]
end

$primitive_fun_env = {
  :+ => [:prim, lambda{|x, y| x + y}],
  :- => [:prim, lambda{|x, y| x - y}],
  :* => [:prim, lambda{|x, y| x * y}]
}

def car(list)
  list[0]
end

def cdr(list)
  list[1..-1]
end

def eval_list(exp)
  exp.map{|e| _eval(e)}
end

def immediate_val?(exp)
  num?(exp)
end

def num?(exp)
  exp.is_a?(Numeric)
end

def apply(fun, args)
  apply_primitive_fun(fun, args)
end

def apply_primitive_fun(fun, args)
  fun_val = fun[1]
  fun_val.call(*args)
end

### environment ###
def lookup_var(var, env)
  alist = env.find{|alist| alist.key?(var)}
  if alist == nil
    raise "couldn't find value to variables:'#{var}'"
  end
  alist[var]
end

def extend_env(parameters, args, env)
  alist = parameters.zip(args)
  h = Hash.new
  alist.each{ |k, v| h[k] = v}
  [h] + env
end

### let ###
def eval_let(exp, env)
  parameters, args, body = let_to_parameters_args_body(exp)
  new_exp = [[:lambda, parameters, body]] + args
  _eval(new_exp, env)
end

def let_to_parameters_args_body(exp)
  [exp[1].map{|e| e[0]}, exp[1].map{|e| e[1]}, exp[2]]
end

def let?(exp)
  exp[0] == :let
end


puts _eval([:+, [:+, 1, 2], 3])
