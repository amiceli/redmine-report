#!/usr/bin/perl

use strict;
use warnings;
use Redmine::Config;
use Redmine::UserRepository;
use Redmine::Api;
use Getopt::Long;
use Redmine::IssueRepository;
use Redmine::IssuePrinter;

my $url;
my $token;
my $username;
my $limit = 10;

GetOptions(
    'token=s'    => \$token,
    'url=s'      => \$url,
    'username=s' => \$username,
    'limit=i'    => \$limit,
);

if ( not defined $token ) {
    die "Token parameter is missing : --token=<your-redmine-token>\n";
}

if ( not defined $url ) {
    die "Url parameter is missing : --token=<your-redmine-url>\n";
}

if ( not defined $username ) {
    die "Username parameter is missing : --username=<your-redmine-username>\n";
}

my $config = new Config( $url, $token, $username );
my $api    = new Api($config);

my $userRepository = new UserRepository( $api, $username );
my $userId         = $userRepository->getUserId();

my $issueRepository = new IssueRepository( $api, $userId, $limit );
my @issues          = $issueRepository->getIssues();

my $printer = new IssuePrinter(@issues);

$printer->display();

