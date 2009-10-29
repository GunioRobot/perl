# LAG (Load Average Graph) | Igor Lins <snake@bsd.com.br>
# Created 2009-10-20, has be done in 30 minutes

# Licensed under GPL v2 (?)

use GD::Graph::lines;

print STDERR "Processing graph\n";

$my_input = "/var/share/snake/perl/uptime/avg.log";
$my_output = "/var/share/snake/perl/uptime/data";

@data =  read_data_from_csv("$my_input")
	or die "Cannot read data from avg.log";

$my_graph = new GD::Graph::lines(3000,300);

$my_graph->set( 
	x_label => 'Horario',
	y_label => 'Load average',
	title => 'Load average durante o dia',
	y_max_value => 2.5,
#	y_tick_number => 6,
#	y_label_skip => 2,
	markers => [ 1, 5 ],
	transparent => 0,
);

$my_graph->set_legend( 'Ultimo min', 'Ultimos 5 min', 'Ultimos 15 min' );
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

