<?php

namespace rosas\arguments;

use GraphQL\Type\Definition\Type;
use craft\gql\types\QueryArgument;
use craft\gql\types\input\criteria\Entry;

class EntryAsFieldArguments extends \craft\gql\base\ElementArguments
{
    public static function getArguments(): array
    {
        // append our argument to common element arguments and any from custom fields
        return array_merge(parent::getArguments(), self::getContentArguments(), [
            'searchRelated' => [
                'name' => 'searchRelated', // this name
                //'type' => Type::listOf(Type::string()),  Type::listOf(QueryArgument::getType()),
                'type' => Type::listOf(Entry::getType()),
                'description' => 'Matches search on entries-as-fields and returns the whole entry.'
            ],
        ]);
    }
}