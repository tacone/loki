import { makeWrapResolversPlugin } from "graphile-utils";
import { isListType } from "graphql";

// Convert every null list to an empty list (`[]`)
export function nullListsToEmptyLists() {
  return makeWrapResolversPlugin(
    (context) => {
      return { scope: context.scope };
    },
    ({ scope }) =>
      async (resolver, user, args, context, _resolveInfo) => {
        const result = await resolver();
        if (result === null && isListType(_resolveInfo.returnType)) {
          return [];
        }

        return result;
      }
  );
}
