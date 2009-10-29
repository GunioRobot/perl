# UMAD (Users on Mikrotik Along the Day) | Igor Lins <snake@bsd.com.br>
# Created 2009-10-27, based on LAG, has be done in 14:30-??:?? minutes

# Licensed under GPL v2 (?)

use GD::Graph::area;
use GD::Graph::colour;

print STDERR "Processing graph\n";

$my_input = "/var/share/snake/perl/umad/users.log";
$my_output = "/var/share/snake/perl/umad/data";

@data =  read_data_from_csv("$my_input")
	or die "Cannot read data from users.log";

$my_graph = new GD::Graph::area(3000,300);

$my_graph->set( 
	x_label => 'Horario',
	y_label => 'Usuarios',
	title => 'Usuarios durante o dia',
	y_max_value => 200,
	y_min_valeu => 50,
	markers => [ 1, 5 ],
	transparent => 0,
	show_values => 1,
  dclrs => ['blue'],
);

$my_graph->set_legend( 'Logados' );
$my_graph->plot(\@data);
save_chart($my_graph, 'graph');

sub save_chart
{
	my $chart = shift or die "Need a chart!";
	my $name = shift or die "Need a name!";
	my $date = `echo -n \`date +%Y-%m-%d\``;
	local(*OUT);

	my $ext = $chart->export_format;

	open(OUT, ">$my_output/$name.$date.$ext") or 
		die "Cannot open $name.$date.$ext for write: $!";
	binmode OUT;
	print OUT $chart->gd->$ext();
	close OUT;
}

sub read_data_from_csv
{
	my $fn = shift;
	my @d = ();

	open(ZZZ, $fn) || return ();

	while (<ZZZ>)
	{
		chomp;
		# you might want Text::CSV here
		my @row = split /,/;

		for (my $i = 0; $i <= $#row; $i++)
		{
			undef $row[$i] if ($row[$i] eq 'undef');
			push @{$d[$i]}, $row[$i];
		}
	}

	close (ZZZ);

	return @d;
}

