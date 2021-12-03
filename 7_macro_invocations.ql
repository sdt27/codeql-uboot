import cpp

from MacroInvocation m_invocat

where m_invocat.getMacro().getName().regexpMatch("ntoh(l|ll|s)")
select m_invocat, "Find all access of ntoh* macro."
