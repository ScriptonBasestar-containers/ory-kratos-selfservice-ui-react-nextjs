import { UiNode, UiNodeAnchorAttributes } from "@ory/client"
import { Button } from "@ory/themes"
import React from "react"

interface Props {
  node: UiNode
  attributes: UiNodeAnchorAttributes
}

export const NodeAnchor = ({ node, attributes }: Props) => {
  return (
    <Button
      data-testid={`node/anchor/${attributes.id}`}
      onClick={(e: React.MouseEvent<HTMLButtonElement>) => {
        e.stopPropagation()
        e.preventDefault()
        window.location.href = attributes.href
      }}
    >
      {attributes.title.text}
    </Button>
  )
}
