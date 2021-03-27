import { Field, ObjectType } from "type-graphql";

@ObjectType()
export class SubmissionStat {
  @Field()
  value: string;

  @Field()
  count: number;

  @Field()
  ratio: number;

  constructor(value: string, count: number, ratio:number) {
    this.value = value;
    this.count = count;
    this.ratio = ratio;
  }
}
