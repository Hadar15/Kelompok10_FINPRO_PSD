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

package body sorter_pkg is
    
    function is_sorted(data : t_data_array) return boolean is
    begin
        for i in 0 to ARRAY_SIZE-2 loop
            if data(i) > data(i+1) then
                return false;
            end if;
        end loop;
        return true;
    end function is_sorted;

    function find_min(data : t_data_array) return SIGNED is
        variable min_val : SIGNED(DATA_WIDTH-1 downto 0);
    begin
        min_val := data(0);
        for i in 1 to ARRAY_SIZE-1 loop
            if data(i) < min_val then
                min_val := data(i);
            end if;
        end loop;
        return min_val;
    end function find_min;

    impure function log_array(data : t_data_array; prefix : string) return integer is
    begin
        report prefix & " - Array logged";
        return 0;
    end function log_array;

    procedure print_array(data : t_data_array; msg : string) is
    begin
        report "=== " & msg & " ===";
        for i in 0 to ARRAY_SIZE-1 loop
            report "  [" & integer'image(i) & "] = " &
                   integer'image(to_integer(data(i)));
        end loop;
    end procedure print_array;

end package body sorter_pkg;
