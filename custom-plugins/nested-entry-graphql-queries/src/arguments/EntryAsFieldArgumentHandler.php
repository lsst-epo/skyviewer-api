<?php

namespace rosas\arguments;

use Craft;
use craft\elements\Entry;
use craft\gql\base\RelationArgumentHandler;

class EntryAsFieldArgumentHandler extends RelationArgumentHandler
{
    protected $argumentName = 'searchRelated';

    protected function handleArgument($argumentValue)
    {
        $argumentValue = parent::handleArgument($argumentValue);
        $ids = $this->getIds(Entry::class, $argumentValue);
        Craft::info("nested-entries-graphql-queries - DEBUG - Returned IDs from 1st query");
        Craft::info($ids);
        return $ids;
    }
}
