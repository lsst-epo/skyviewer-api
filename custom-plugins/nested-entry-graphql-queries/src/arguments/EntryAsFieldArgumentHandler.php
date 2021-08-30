<?php

namespace rosas\arguments;

use Craft;
use craft\elements\Entry;
use craft\gql\base\RelationArgumentHandler;
use craft\elements\MatrixBlock;

class EntryAsFieldArgumentHandler extends RelationArgumentHandler
{
    protected $argumentName = 'searchRelated';

    protected function handleArgument($argumentValue)
    {
        $argumentValue = parent::handleArgument($argumentValue);
        $ids = $this->getIds(Entry::class, $argumentValue);
        $relatedIds = MatrixBlock::find()->select('ownerId')->relatedTo($ids)->column();
        if(count($relatedIds) == 0) {
            return [0];
        }
        return array_unique($relatedIds);
    }

    public function handleArgumentCollection(array $argumentList = []): array
    {
        if (!array_key_exists($this->argumentName, $argumentList)) {
            return $argumentList;
        }

        static $memoizedValues = [];
        $argumentValue = $argumentList[$this->argumentName];
        $hash = md5(serialize($argumentValue));

        Craft::info("dingo");
        Craft::info($memoizedValues);

        // Has this argument already been added?
        if (!array_key_exists($hash, $memoizedValues)) {
            $memoizedValues[$hash] = $this->handleArgument($argumentValue);
        }

        $foundIds = $memoizedValues[$hash];

        // If they requested specific ids already, intersect with our search results
        // Useful if they provide a search argument AND and id argument or ids argument
        if (!empty($argumentList['id'])) {
            $foundIds = array_intersect($argumentList['id'], $foundIds);

        }
        $argumentList['id'] = $foundIds;

        unset($argumentList[$this->argumentName]);
        return $argumentList;
    }
}
