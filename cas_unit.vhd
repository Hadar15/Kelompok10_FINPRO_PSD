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
begin


end Behavioral;