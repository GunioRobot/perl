use GD::Graph::lines;

print STDERR "Processing graph\n";

@data =  read_data_from_csv("data.csv")
	or die "Cannot read data from data.csv";

$my_graph = new GD::Graph::lines( );

$my_graph->set( 
	x_label => 'Dia',
	y_label => 'Porcentagem',
	title => 'Variacao dos acessos totais e os cache hits',
	y_max_value => 1500000,
	markers => [ 1, 5 ],
	transparent => 0,
);

$my_graph->set_legend( '% Total Accesses', 'Total Cache Hits' );
$my_graph->plot(\@data);
save_chart($my_graph, 'graph');

sub save_chart
{
	my $chart = shift or die "Need a chart!";
	my $name = shift or die "Need a name!";
	my $date = `echo -n \`date +%Y-%m\``;
	local(*OUT);

	my $ext = $chart->export_format;

	open(OUT, ">$name.$date.$ext") or 
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

