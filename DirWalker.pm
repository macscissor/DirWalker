#!/usr/bin/perl
##
##ToDo:
#use strict;
#use warnings;
use Data::Dumper qw(Dumper);
use utf8;

package DirWalker;
warn "DirWalker walking...\n\n";

sub new {
	$class = shift;

	$object = [ {} ];

	bless($object, $class);
	return $object;
}

sub setpath {
    $object = shift;
	$path = shift;

	$object->[0] = $path;
	$object = getcontent($object);

    return $object;
}

sub news {
	$class = shift;
	$path = shift;

	$object = [ {} ];

	bless($object, $class);
	
	$object->[0] = $path;
	$object = getcontent($object);

	return $object;
}

sub getcontent {
	$object = shift;
	$path = $object->[0];
	@content = ();

	if (-d $path) {
		$path = $object->[0];
		@content = `ls -la $path`;
		shift @content;
	
		$i = 1;

		foreach (@content) {	
			chomp $_;

			($attr, $hl, $owner, $group, $size, $day, $mon, $time, $name) = split(/\s+/, $_);
			if (($name ne ".") and ($name ne "..")) {
					$object->[$i]{name} = $name;
					$object->[$i]{attr} = $attr;
					$object->[$i]{hl} = $hl;
					$object->[$i]{owner} = $owner;
					$object->[$i]{group} = $group;
					$object->[$i]{size} = $size;
					$object->[$i]{mon} = $mon;
					$object->[$i]{day} = $day;
					$object->[$i]{time} = $time;
					$i++;
			}

		}
		return $object;
	}
	else {
		warn "Couldn't open $path: $!\n";
		return 0;
	}

}

sub getpath {
	$object = shift;
	return $object->[0];
}

sub getfiles {
	$object = shift;
	$pattern = shift;
	@files = ();

	for ($i = 1; $i < scalar @$object; $i++) {
		$name = $object->[$i]{name};
		if ($pattern) {
			if (($name eq $pattern) and (-f "$path/$name")) {
				push @files, $name;
				print "pattern\n";
				print $name . "\n";
				print scalar @files . "\n";
			}
		}
		else {
			if (-f "$path/$name") {
				push @files, $name;
				print "no pattern\n";
				print $name . "\n";
				print scalar @files . "\n";
			}
		}
	}
	return \@files;
}

sub getdirs {
	$object = shift;
	$pattern = shift;
	@dirs = ();

	for ($i = 1; $i < scalar @$object; $i++) {
		$name = $object->[$i]{name};
		if ($pattern) {
			if (($name eq $pattern) and (-d "$path/$name")) {
				push @dirs, $name;
			}
		}
		else {
			if ((-d "$path/$name") and ($name ne "..") and ($name ne ".")) {
				push @dirs, $name;
			}
		}
	}
	return \@dirs;
}

sub descend {
	$object = shift;
	$descdir = shift;
	$path = $object->[0];
	$descpath = "$path/$descdir";

	return $object = setpath($object, $descpath);
}

1;
