<?php

namespace rosas\resolvers;

use mynamespace\elements\Widget as WidgetElement;
use mynamespace\helpers\Gql as GqlHelper;

class EntryAsFieldResolver extends craft\gql\base\ElementResolver
{
    public static function prepareQuery($source, array $arguments, $fieldName = null)
    {
        if ($source === null) {
            // If this is the beginning of a resolver chain, start fresh
            $query = WidgetElement::find();
        } else {
            // If not, get the prepared element query
            $query = $source->$fieldName;
        }

        // Return the query if it’s preloaded
        if (is_array($query)) {
            return $query;
        }

        foreach ($arguments as $key => $value) {
            if (method_exists($query, $key)) {
                $query->$key($value);
            } elseif (property_exists($query, $key)) {
                $query->$key = $value;
            } else {
                // Catch custom field queries
                $query->$key($value);
            }
        }

        // Don’t return anything that’s not allowed
        if (!GqlHelper::canQueryWidgets()) {
            return [];
        }

        return $query;
    }
}