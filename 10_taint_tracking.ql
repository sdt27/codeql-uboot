import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr {
    NetworkByteSwap() {
        exists(
            MacroInvocation mi | 
            mi.getMacro().getName().regexpMatch("ntoh(l|ll|s)") and
            this = mi.getExpr()
        )
    }
}

class FunctionCallMemcpy extends Expr {
    FunctionCallMemcpy() {
        exists(
            FunctionCall fc | fc.getTarget().getName() = "memcpy" and
            this = fc.getArgument(2) and not fc.getArgument(1).isConstant()
        ) 
    }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
      source.asExpr() instanceof NetworkByteSwap
  }
  override predicate isSink(DataFlow::Node sink) {
      sink.asExpr() instanceof FunctionCallMemcpy
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"
