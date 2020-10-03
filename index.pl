#!/usr/bin/perl

use strict;
use warnings;
use Redmine::Config;
use Redmine::UserRepository;
use Redmine::Api;
use Getopt::Long;
use Redmine::IssueRepository;
use Redmine::IssuePrinter;
use Data::Dumper;
use Term::ReadKey;


my $url;
my $token;
my $username;
my $limit;

GetOptions (
    'token=s' => \$token, 
    'url=s' => \$url, 
    'username=s' => \$username,
    'limit=i' => \$limit
);

if (not defined $limit) {
    $limit = 5;
}

if (not defined $token) {
    die "Token parameter is missing : --token=<your-redmine-token>\n";
}

if (not defined $url) {
    die "Url parameter is missing : --token=<your-redmine-url>\n";
}

if (not defined $username) {
    die "Username parameter is missing : --username=<your-redmine-username>\n";
}

my $config = new Config($url, $token, $username);
my $api = new Api($config);

my $userRepository = new UserRepository($api, $username);
my $userId = $userRepository->getUserId();

my $issueRepository = new IssueRepository($api, $userId, $limit);
my @issues = $issueRepository->getIssues();

my $display = new IssuePrinter(@issues);
$display->clear()->dynamic();

sub waitInput {
    ReadMode('cbreak');
    my $key = ReadKey(0);
    ReadMode('normal');

    return $key;
}

my $key = '';

while (not $key eq 'q') {
    $key = waitInput();

    if ($key eq 's') {
        $display->selectNext()->clear()->dynamic();
    }
    if ($key eq 'z') {
        $display->selectPrevious()->clear()->dynamic();
    }
    if ($key eq 'r') {
        @issues = $issueRepository->getIssues();
        $display = new IssuePrinter(@issues);

        $display->clear()->dynamic();
    }
    if ($key eq 'o') {
        my $id = $display->getCurrentIssue()->{id};
        my $url = $config->{url} . '/redmine/issues/' . $id;

        system('open', $url);
    }
    if ($key eq 'c') {
        my $id = $display->getCurrentIssue()->{id};
        my $url = $config->{url} . '/redmine/issues/' . $id;

        system("echo '$url'| pbcopy");
    }    
}

print "exit\n";


