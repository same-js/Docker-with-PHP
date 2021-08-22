<?php
mb_internal_encoding("UTF-8");
mb_language('uni');
echo(
    mb_send_mail(
        to: 'to@example.com',
        subject: 'テストメールの件名です',
        message: 'テストメールの本文です',
        additional_headers: [
            'From' => 'from@example.com'
        ],
    )
)
? 'success. Check e-mail on mailhog.'
: 'failure. Check the Dockerfile or docker-compose.yml.'
;
