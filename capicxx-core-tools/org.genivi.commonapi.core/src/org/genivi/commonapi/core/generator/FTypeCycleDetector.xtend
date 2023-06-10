/* Copyright (C) 2013-2020 Bayerische Motoren Werke Aktiengesellschaft (BMW AG)
   This Source Code Form is subject to the terms of the Mozilla Public
   License, v. 2.0. If a copy of the MPL was not distributed with this
   file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package org.genivi.commonapi.core.generator

import java.util.HashMap
import java.util.List
import java.util.Stack
import org.franca.core.franca.FType
import javax.inject.Inject

class FTypeCycleDetector {
	@Inject
	extension FrancaGeneratorExtensions francaGeneratorExtensions

    val indices = new HashMap<FType, Integer>
	val lowlink = new HashMap<FType, Integer>
	val stack = new Stack<FType>
	var int index
    public var String outErrorString

    new(FrancaGeneratorExtensions francaGeneratorExtensions) {
        this.francaGeneratorExtensions = francaGeneratorExtensions
    }

    new() {
    }

    def dispatch boolean hasCycle(FType type) {
        indices.clear()
        lowlink.clear()
        stack.clear()
        index = 0
        outErrorString = type.elementName + "->";
        return tarjan(type)
    }

    def dispatch boolean hasCycle(List<FType> types) {
        indices.clear()
        lowlink.clear()
        stack.clear()
        index = 0

        val typeWithCycle = types.findFirst[type|!indices.containsKey(type) && tarjan(type)]

        return typeWithCycle !== null
    }

    // Tarjan's Strongly Connected Components Algorithm
    // returns true if a cycle was detected
    /**
     * Tarjan's Strongly Connected Components Algorithm
     *
     * @param type
     *            start searching from type.
     * @return <code>true</code> if a dependency cycle was detected.
     */
    def private boolean tarjan(FType type) {
        indices.put(type, index)
        lowlink.put(type, index)
        index = index + 1

        stack.push(type)

        val directlyReferencedTypes = type.directlyReferencedTypes

        for (referencedType : directlyReferencedTypes) {
            outErrorString = outErrorString + referencedType.elementName + "->"
            if (!indices.containsKey(referencedType)) {
                if (tarjan(referencedType))
                    return true

                lowlink.put(
                    type,
                    Math::min(lowlink.get(type), lowlink.get(referencedType))
                );
            } else if (stack.contains(referencedType))
                lowlink.put(
                    type,
                    Math::min(lowlink.get(type), indices.get(referencedType))
                );
        }

        // if scc root and not on top of stack, then we have a cycle (scc size > 1)
        if (lowlink.get(type) == indices.get(type) && !stack.pop().equals(type)) {
            outErrorString = outErrorString.subSequence(0, outErrorString.length - 2) as String
            return true;
        }

        return false
    }
}
