package MooseX::Speech;
use Moose::Role;
use Speech::Synthesis;

has speech_engine => (
    isa     => 'Str',
    is      => 'ro',
    default => sub { 'MacSpeech'; },
);

# TODO: This should become a Type
# with a coercion from Str to do the grep()

has voice => (
    isa     => 'HashRef',
    is      => 'ro',
    default => sub {
        my ($voice) =
          grep { $_->{name} eq 'Vicki' }
          Speech::Synthesis->InstalledVoices( engine => $_[0]->speech_engine );
        return $voice;
    },
);

has _voicebox => (
    isa     => 'Speech::Synthesis',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $voice = $_[0]->voice;
        return Speech::Synthesis->new(
            engine   => $_[0]->speech_engine,
            language => $voice->{language},
            voice    => $voice->{id},
            async    => 0,
        );
    },
    handles => [qw[speak]],
);

no Moose::Role;
1;
