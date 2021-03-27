import { Arg, Mutation, Query, Resolver } from "type-graphql";
import { SubmissionInput } from "../input/SubmissionInput";
import { Submission } from "../models/Submission";
import SubmissionStatisticsType from "../types/SubmissionStatisticsType";

@Resolver()
export class SubmissionResolver {
  @Query(() => String)
  hello() {
    return "world";
  }

  @Query(() => [Submission])
  submissions() {
    return Submission.find();
  }

  @Query(() => Submission)
  submission(@Arg("id") id: String) {
    return Submission.findOne({ where: { id } });
  }

  @Query(() => SubmissionStatisticsType)
  async submission_statistics() {
    return new SubmissionStatisticsType();
  }

  @Mutation(() => Submission)
  async create_submission(@Arg("data") data: SubmissionInput) {
    const record = Submission.create(data);
    await record.save();
    return record;
  }
}
