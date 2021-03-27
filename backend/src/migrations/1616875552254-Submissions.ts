import {MigrationInterface, QueryRunner} from "typeorm";

export class Submissions1616875552254 implements MigrationInterface {
    name = 'Submissions1616875552254'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "submissions" ("id" SERIAL NOT NULL, "name" character varying NOT NULL, "email_address" character varying NOT NULL, "age" integer DEFAULT null, "gender" character varying DEFAULT null, "country" character varying DEFAULT null, "experience_rating" integer DEFAULT null, "suggested_improvements" character varying DEFAULT null, "referrer" character varying DEFAULT null, "created_at" date NOT NULL DEFAULT CURRENT_TIMESTAMP, CONSTRAINT "PK_10b3be95b8b2fb1e482e07d706b" PRIMARY KEY ("id"))`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "submissions"`);
    }

}
