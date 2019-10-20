package  my_112l_pkg;

	typedef struct packed{
		logic [8:0]   pc_next;
		logic [31:0] instr;
	} if_id_reg_t;

endpackage


//////add to RTL.cfg