import { Field, InputType, Int } from "type-graphql";
@InputType()
export class SubmissionInput {
  @Field()
  name: string;

  @Field()
  email_address: string;

  @Field(() => Int, { nullable: true })
  age: number;

  @Field({ nullable: true })
  gender: string;

  @Field({ nullable: true })
  country: string;

  @Field(() => Int, { nullable: true })
  experience_rating: number;

  @Field({ nullable: true })
  suggested_improvements: string;

  @Field({ nullable: true })
  referrer: string;
}
