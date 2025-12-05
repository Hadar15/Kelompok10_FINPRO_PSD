library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package sorter_pkg is
    constant DATA_WIDTH : integer := 16;
    constant ARRAY_SIZE : integer := 16;

    type t_data_array is array (0 to ARRAY_SIZE-1) of SIGNED(DATA_WIDTH-1 downto 0);

    function is_sorted(data : t_data_array) return boolean;
    function find_min(data : t_data_array) return SIGNED;
    impure function log_array(data : t_data_array; prefix : string) return integer;
    procedure print_array(data : t_data_array; msg : string);
end package sorter_pkg;
