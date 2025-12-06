library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sorter_pkg.all;

entity cas_unit is
    Port (
        i_val_a : in  SIGNED(DATA_WIDTH-1 downto 0);
        i_val_b : in  SIGNED(DATA_WIDTH-1 downto 0);
        o_min   : out SIGNED(DATA_WIDTH-1 downto 0);
        o_max   : out SIGNED(DATA_WIDTH-1 downto 0)
    );
end cas_unit;

architecture Behavioral of cas_unit is 

function get_min(val1, val2: SIGNED) return SIGNED is
begin
    if val1 <= val2 then
        return val1;
    else
        return val2;
    end if;
end function get_min;

function get_max(val1, val2 : SIGNED) return SIGNED is
begin
    if val1 >= val2 then
        return val1;
    else
        return val2;
    end if;
end function get_max;


begin
    o_min <= get_min(i_val_a, i_val_b);
    o_max <= get_max(i_val_a, i_val_b);

end Behavioral;